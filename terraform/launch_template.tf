resource "aws_launch_template" "docker_host_template" {
  name_prefix   = "docker_host_template"
  image_id      = "ami-052c9ea013e6e3567"
  instance_type = "t2.micro"
  key_name      = "new-key"
  user_data     = filebase64("install_docker.sh")
  vpc_security_group_ids = [aws_security_group.private_instance.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2ContainerProfile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_autoscaling_group" "docker_asg" {
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.docker_host_template.id
    version = "$Latest"  # Ensure this is wrapped in double quotes
  }

  depends_on = [aws_iam_role.ec2_role, aws_iam_role_policy_attachment.ec2_policy_attachment, aws_launch_template.docker_host_template]

  target_group_arns = [aws_lb_target_group.docker_target_group.arn] 
}



# Create SSH Bastion Host in Public Subnet
resource "aws_instance" "ssh_bastion" {
  ami           = "ami-052c9ea013e6e3567"
  instance_type = "t2.micro"
  key_name      = "new-key"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ssh_bastion.id]

  tags = {
    Name = "SSH Bastion Host"
  }
}
