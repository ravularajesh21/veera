local {
    name = "${local.project_name}-${local.environment}"
}
local {
    az_names = slice(data.availability_zone.az_names.name,0,2)
}
