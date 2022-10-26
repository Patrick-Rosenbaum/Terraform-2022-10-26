resource "azurerm_resource_group" "patrick_rosenbaum_resource_group" {
  name     = "${var.Ressource_Group_Name}${formatdate("YYYY-MM-DD",timestamp())}"
  location = var.Ressource_Group_Location
}

resource "azurerm_storage_account" "patrick_rosenbaum_storage" {
  name                     = "storage20221025"
  resource_group_name      = "${var.Ressource_Group_Name}${formatdate("YYYY-MM-DD",timestamp())}"
  location                 = var.Ressource_Group_Location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  depends_on = [
    azurerm_resource_group.patrick_rosenbaum_resource_group
  ]

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "patrick_rosenbaum_container" {
  for_each = toset(["terraformcontainer", "container2", "mycontainer"])
  name                  = "storage-${each.key}"
  storage_account_name  = azurerm_storage_account.patrick_rosenbaum_storage.name
  container_access_type = "blob"

  depends_on = [
    azurerm_storage_account.patrick_rosenbaum_storage
  ]
}

# die trim function wird nicht hervorgehoben weshalb ich davon ausgehe das es nicht funktioniert
# und für die for_each schleife für die container namen hab ich hier leider keine lösung gefunden

/*resource "azurerm_storage_blob" "patrick_rosenbaum_blob" {
  for_each = fileset(path.module, "file_uploads/*")
  name                   = trim(each.key, "file_uploads/*")
  storage_account_name   = azurerm_storage_account.patrick_rosenbaum_storage.name
  storage_container_name = azurerm_storage_container.patrick_rosenbaum_container
  type                   = "Block"
  source                 = "file_uploads/*"
} */