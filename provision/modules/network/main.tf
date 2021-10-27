module "vpc" {
  source      = "./vpc"
}

resource "aws_internet_gateway" "public" {
  vpc_id = module.vpc.vpc_id
}

module "public_subnet" {
  source      = "./public_subnet"
  vpc_id      = module.vpc.vpc_id
  gateway_id  = aws_internet_gateway.public.id
}

module "private_subnet" {
  source      = "./private_subnet"
  vpc_id      = module.vpc.vpc_id
}
