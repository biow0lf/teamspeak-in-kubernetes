variable "namespace" {
  description = "Kubernetes namespace"
}

variable "teamspeak_db_hostname" {
  description = "MariaDB teamspeak database hostname"
}

variable "teamspeak_db_port" {
  description = "MariaDB teamspeak database port"
  default     = "3306"
}

variable "teamspeak_db_user" {
  description = "MariaDB teamspeak user name"
}

variable "teamspeak_db_password" {
  description = "MariaDB teamspeak user password"
}

variable "teamspeak_db_name" {
  description = "MariaDB teamspeak database name"
}

variable "teamspeak_serveradmin_password" {
  description = "Serveradmin password"
}

variable "teamspeak_voice_port" {
  description = "Teamspeak Voice port"
  default     = "9987"
}

variable "teamspeak_query_raw_port" {
  description = "Teamspeak ServerQuery (raw) port"
  default     = "10011"
}

variable "teamspeak_query_ssh_port" {
  description = "Teamspeak ServerQuery (SSH) port"
  default     = "10022"
}

variable "teamspeak_filetransfer_port" {
  description = "Teamspeak Filetransfer port"
  default     = "30033"
}
