resource "aws_vpc" "main" {
    vpc_id = var.vpc_cidr
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = local.name
        }
    )
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            Name = local.name
        }
    )
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        var.common_tags,
        var.public_subnets_tags, {
            Name = "${local.name}-public-${az_names[count.index]}
        }
    )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.common_tags,
        var.private_subnets_tags,
        {
            Name = "${local.name}-private-${local.az_names[count.index]}
        }
    )
}

resource "aws_subnet" "database" {
    count = length(var.database_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.common_tags,
        var.database_subnets_tags,
        {
            Name = "${local.name}-database-${local.az_names[count.index]}"
        }
    )
}

resource "aws_db_subnet_group" "group" {
    name = "${local.name}"
    subnet_ids = aws_subnet.database[*].id
    tags = {
        Name = local.name
    }
}

resource "aws_eip" "eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public[0].id

    tags = {
        Name = local.name
    }
    depends_on = [aws_internet_gateway]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = merge(
        var.common_tags,
        var.public_route_table_tags,
        {
            Name = ${local.name}"
        }
    )

}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    tags = merge(
        var.common_tags,
        var.private_route_table_tags,
        {
            Name = "${local.name}"
        }
    )
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id
    tags = merge(
        var.common_tags,
        var.database_route_table_tags,
        {
            Name = "${local.name}"
        }
    )
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.main.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
    route_table_id = aws_route_table.private.main.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}
resource "aws_route" "database" {
    route_table_id =aws_route_table.database.main.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets_cidr)
    subnet_id = element(aws_subnet.public[*].id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets_cidr)
    subnet_id = aws_route_table.private[*].id, count.index
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    count = length(Var.database_subnets_cidr)
    subnet_id = aws_subnet.database[*].id, count.index
    route_table_id = aws_route_table.database.id
}