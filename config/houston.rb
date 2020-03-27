require 'houston'
APN = Houston::Client.development
APN.certificate = File.read('wishroll-dev-push.pem')