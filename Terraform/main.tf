# Создание виртуалки
resource "aws_instance" "vms" {
    # Количество создаваемых виртуальных машин
    for_each = toset(var.vms)

    # Наименование типа экземпляра создаваемой ВМ — из переменной vm_instance_type
    instance_type = var.vm_instance_type

    # ID образа для создания экземпляра ВМ — из переменной vm_template
    ami = var.vm_template

    # Назначаем экземпляру внутренний IP-адрес из созданной ранее подсети в VPC
    subnet_id = var.vm_subnet

    # Подключаем к создаваемому экземпляру внутреннюю группу безопасности
    vpc_security_group_ids = [var.vm_securitygroup]

    # Не выделяем и не присваиваем экземпляру внешний Elastic IP
    associate_public_ip_address = false

    # Не активируем мониторинг экземпляра
    monitoring = false

  tags = {
    Name = "${var.vm_name_prefix} ${each.key}"
  }

  # Создаём диск, подключаемый к экземпляру
  ebs_block_device {
    # Говорим удалять диск вместе с экземпляром
    delete_on_termination = true
    # Задаём имя устройства вида "disk<N>",
    device_name = "disk1"
    # его тип
    volume_type = var.vm_volume_type
    # и размер
    volume_size = var.vm_volume_size

    tags = {
      Name = "Disk for ${var.vm_name_prefix} ${each.key}"
    }
  }
}

####################################################################################################
resource "random_password" "password" {
  count   = length(var.vms) * var.password_count
  length  = 24
}