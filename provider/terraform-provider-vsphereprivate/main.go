package main

import (
	"example.com/terraform-provider-vsphereprivate/vsphereprivate"
	"github.com/hashicorp/terraform-plugin-sdk/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: vsphereprivate.Provider})

	/*
		vspherePrivateProvider := func() {
		}
		//KnownPlugins["terraform-provider-vsphereprivate"] = vspherePrivateProvider
	*/
}
