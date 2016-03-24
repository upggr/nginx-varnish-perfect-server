vcl 4.0;
import std;

backend default {
  .host = "127.0.0.1";
  .port = "8080";
  .first_byte_timeout = 60s;
  .connect_timeout = 1s;
 .between_bytes_timeout = 2s;
}

acl purge {
  "localhost";
  "127.0.0.1";
}

sub vcl_recv {
set req.http.X-Actual-IP = regsub(req.http.X-Forwarded-For, "[, ].*$", "");
  if (req.restarts == 0) {
    if (req.http.x-forwarded-for) {
      set req.http.X-Forwarded-For =
      req.http.X-Forwarded-For + ", " + client.ip;
    } else {
      set req.http.X-Forwarded-For = client.ip;
    }
  }

if (req.http.Cache-Control ~ "no-cache") {
    if (client.ip ~ purge || std.ip(req.http.X-Actual-IP, "1.2.3.4") ~ purge) {
         set req.hash_always_miss = true;
    }
}

if (req.method == "PURGE") {
    if (!client.ip ~ purge || !std.ip(req.http.X-Actual-IP, "1.2.3.4") ~ purge) {
        return(synth(405,"Not allowed."));
        }
    return (purge);
  }

if (req.method == "BAN") {
        if (!client.ip ~ purge || !std.ip(req.http.X-Actual-IP, "1.2.3.4") ~ purge) {
                        return(synth(403, "Not allowed."));
        }
        ban("req.http.host == " + req.http.host +
                  " && req.url == " + req.url);
        return(synth(200, "Ban added"));
}

      set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(_[_a-z]+|has_js)=[^;]*", "");
     set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");

 if (req.url ~ "/feed(/)?") {
        return ( pass );
}


if (req.url ~ "/\?s\=") {
       return ( pass );
}


  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
      # No point in compressing these
      unset req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      # unknown algorithm
      unset req.http.Accept-Encoding;
    }
  }


  if (req.method != "GET" &&
    req.method != "HEAD" &&
    req.method != "PUT" &&
    req.method != "POST" &&
    req.method != "TRACE" &&
    req.method != "OPTIONS" &&
    req.method != "DELETE") {
      return (pipe);
  }


  if (req.method != "GET" && req.method != "HEAD") {
    return (pass);
  }


  if ( req.http.cookie ~ "wordpress_logged_in" ) {
    return( pass );
 }


  if (!(req.url ~ "wp-(login|admin)")
    && !(req.url ~ "&preview=true" )
  ){
    unset req.http.cookie;
  }


  if (req.http.Authorization || req.http.Cookie) {
    return (pass);
  }


  return (hash);
  # This is for phpmyadmin
if (req.http.Host == "pmadomain.com") {
return (pass);
}
}


sub vcl_hit {
  return (deliver);
}


sub vcl_miss {
  return (fetch);
}


sub vcl_backend_response {
  set beresp.http.Vary = "Accept-Encoding";
  if (!(bereq.url ~ "wp-(login|admin)") && !bereq.http.cookie ~ "wordpress_logged_in" ) {
    unset beresp.http.set-cookie;
    set beresp.ttl = 52w;
  }

  if (beresp.ttl <= 0s ||
    beresp.http.Set-Cookie ||
    beresp.http.Vary == "*") {
      set beresp.ttl = 120 s;
      # set beresp.ttl = 120s;
      set beresp.uncacheable = true;
      return (deliver);
  }

  return (deliver);
}

sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }
}
