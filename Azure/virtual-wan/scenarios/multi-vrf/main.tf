# main module to deploy network and webVM
provider "azurerm" {
  features {}
}

resource "azurerm_virtual_hub_route_table" "Red_H1" {
  name           = "Red"
  virtual_hub_id = data.azurerm_virtual_hub.VH_R1.id
}

resource "azurerm_virtual_hub_route_table" "Blue_H1" {
  name           = "Blue"
  virtual_hub_id = data.azurerm_virtual_hub.VH_R1.id
}

resource "azurerm_virtual_hub_route_table" "Red_H2" {
  name           = "Red"
  virtual_hub_id = data.azurerm_virtual_hub.VH_R2.id
}

resource "azurerm_virtual_hub_route_table" "Blue_H2" {
  name           = "Blue"
  virtual_hub_id = data.azurerm_virtual_hub.VH_R2.id
}

resource "azurerm_virtual_hub_connection" "R1_Red_1" {
  name                      = "R1_Red_1"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R1_Red_1.id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.Red_H1.id
    propagated_route_table {
      route_table_ids = [ azurerm_virtual_hub_route_table.Red_H1.id ]
    }
  }
}

resource "azurerm_virtual_hub_connection" "R1_Red_2" {
  name                      = "R1_Red_2"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R1_Red_2.id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.Red_H1.id
    propagated_route_table {
      route_table_ids = [ azurerm_virtual_hub_route_table.Red_H1.id ]
    }
  }
}

resource "azurerm_virtual_hub_connection" "R2_Red_1" {
  name                      = "R2_Red_1"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R2.id
  remote_virtual_network_id = data.azurerm_virtual_network.R2_Red_1.id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.Red_H2.id
    propagated_route_table {
      route_table_ids = [ azurerm_virtual_hub_route_table.Red_H2.id ]
    }
  }
}

resource "azurerm_virtual_hub_connection" "R2_Red_2" {
  name                      = "R2_Red_2"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R2.id
  remote_virtual_network_id = data.azurerm_virtual_network.R2_Red_2.id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.Red_H2.id
    propagated_route_table {
      route_table_ids = [ azurerm_virtual_hub_route_table.Red_H2.id ]
    }
  }
}

resource "azurerm_virtual_hub_connection" "R1_Blue" {
  name                      = "R1_Blue"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R1_Blue.id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.Blue_H1.id
    propagated_route_table {
      route_table_ids = [ azurerm_virtual_hub_route_table.Blue_H1.id ]
    }
  }
}

resource "azurerm_virtual_hub_connection" "R2_Blue" {
  name                      = "R2_Blue"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R2.id
  remote_virtual_network_id = data.azurerm_virtual_network.R2_Blue.id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.Blue_H2.id
    propagated_route_table {
      route_table_ids = [ azurerm_virtual_hub_route_table.Blue_H2.id ]
    }
  }
}
