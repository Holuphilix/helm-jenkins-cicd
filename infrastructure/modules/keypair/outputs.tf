output "key_name" {
  value = aws_key_pair.jenkins_key.key_name
}

output "private_key_path" {
  value = local_file.private_key_pem.filename
  description = "Path to the saved private key file"
}
