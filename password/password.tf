variable "length" {
  default = "20"
}

resource "random_id" "password" {
  byte_length = "${var.length * 3 / 4}"
}

output "password" {
  value = "${random_id.password.b64}"
}