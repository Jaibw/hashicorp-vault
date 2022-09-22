storage "consul" {
        address = "SERVERIP_ADDRESS:8500"
        path = "vault/"
}
listener "tcp" {
        address = "0.0.0.0:80"
        tls_disable = 1
}
ui = true
