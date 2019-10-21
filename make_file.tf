# Create first file from template with vars defined below.
data "template_file" "test" {
  template = file("files/test.txt.tpl")

  vars = {
    test_string = "this is a file"
  }
}

# Create second file from template file with vars and a normal file.
data "template_file" "test2" {
  template = file("files/test2.txt.tpl")

  vars = {
    test_file  = data.template_file.test.rendered
    test_file3 = file("files/test3.txt")
  }
}

# Use a null resource to actually write the file.
resource "null_resource" "write_file" {
  provisioner "local-exec" {
    command = <<EOT
    echo "${data.template_file.test2.rendered}" > test_file.txt
    
EOT

  }
}

output "test_file" {
  value = data.template_file.test2.rendered
}

