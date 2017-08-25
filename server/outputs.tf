output "server_address" {
    value = "${aws_instance.default.public_dns}"
}

output "public_ip" {
    value = "${aws_instance.default.public_ip}"
}

output "name" {
    value = "${aws_instance.default.tags.Name}"
}