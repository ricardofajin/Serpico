require 'openssl'

# create the SSL cert
puts "Creating self-signed SSL certificate, you should really have a legitimate one."

name = "/C=US/ST=MD/L=MD/O=MD/CN=serpico"
ca   = OpenSSL::X509::Name.parse(name)
key = OpenSSL::PKey::RSA.new(1024)

crt = OpenSSL::X509::Certificate.new
crt.version = 2
crt.serial  = rand(10**10)
crt.subject = ca
crt.issuer = ca
crt.public_key = key.public_key
crt.not_before = Time.now
crt.not_after  = Time.now + 1 * 365 * 24 * 60 * 60 # 1 year

ef = OpenSSL::X509::ExtensionFactory.new
ef.subject_certificate = crt
ef.issuer_certificate = crt
crt.extensions = [
    ef.create_extension("basicConstraints","CA:TRUE", true),
    ef.create_extension("subjectKeyIdentifier", "hash"),
]
crt.add_extension ef.create_extension("authorityKeyIdentifier",
                                      "keyid:always,issuer:always")
crt.sign key, OpenSSL::Digest::SHA1.new

File.open("./cert.pem", "w") do |f|
    f.write crt.to_pem
end

File.open("./key.pem", "w") do |f|
    f.write key.to_pem
end

# Copying the default configurations over
puts "Copying configuration settings over."
File.open("./config.json", "w") do |f|
    f.write File.open("./config.json.defaults", "rb").read
end
