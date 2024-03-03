1. **Script 1: Creating an Azure Virtual Machine**

```go
package main

import (
    "context"
    "fmt"
    "github.com/Azure/azure-sdk-for-go/profiles/latest/compute/mgmt/compute"
    "github.com/Azure/azure-sdk-for-go/sdk/to"
    "github.com/Azure/go-autorest/autorest/azure/auth"
)

func main() {
    // Create an Azure authentication authorizer
    authorizer, err := auth.NewAuthorizerFromEnvironment()
    if err != nil {
        fmt.Println("Error creating authorizer:", err)
        return
    }

    // Create a virtual machine client
    vmClient := compute.NewVirtualMachinesClient("subscription-id")
    vmClient.Authorizer = authorizer

    // Specify VM configuration
    vmName := "my-vm"
    resourceGroup := "my-resource-group"
    location := "eastus"
    vmSize := "Standard_B1s"
    adminUsername := "adminUser"
    adminPassword := "password123"

    vmParams := compute.VirtualMachine{
        Location: to.StringPtr(location),
        OSProfile: &compute.OSProfile{
            ComputerName:  to.StringPtr(vmName),
            AdminUsername: to.StringPtr(adminUsername),
            AdminPassword: to.StringPtr(adminPassword),
        },
        HardwareProfile: &compute.HardwareProfile{
            VMSize: compute.VirtualMachineSizeTypes(vmSize),
        },
        StorageProfile: &compute.StorageProfile{
            ImageReference: &compute.ImageReference{
                Publisher: to.StringPtr("Canonical"),
                Offer:     to.StringPtr("UbuntuServer"),
                Sku:       to.StringPtr("16.04-LTS"),
                Version:   to.StringPtr("latest"),
            },
        },
    }

    // Create the VM
    _, err = vmClient.CreateOrUpdate(context.Background(), resourceGroup, vmName, vmParams)
    if err != nil {
        fmt.Println("Error creating VM:", err)
        return
    }

    fmt.Println("Virtual machine created successfully")
}

