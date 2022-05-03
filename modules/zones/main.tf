resource "aws_route53_zone" "this" {
  for_each = var.create ? var.zones : tomap({})

  name          = try(each.value.domain_name, each.key)
  comment       = try(each.value.comment, null)
  force_destroy = try(each.value.force_destroy, false)

  delegation_set_id = try(each.value.delegation_set_id, null)

  dynamic "vpc" {
    for_each = try(tolist(try(each.value.vpc, [])), [try(each.value.vpc, {})])

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = try(vpc.value.vpc_region, null)
    }
  }

  tags = merge(
    try(each.value.tags, {}),
    var.tags
  )
}
