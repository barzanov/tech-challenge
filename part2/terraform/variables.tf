variable "name" {
  description = "Name of resources"
  type        = string
  default     = "lambda-vpc-list"
}
variable "table_name" {
  description = "Name of table"
  type        = string
  default     = "VpcSubnetData"
}