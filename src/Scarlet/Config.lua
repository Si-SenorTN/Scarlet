return {

	----------------------
	---- Global ----------
	----------------------

	ReplicationFolderName = "ReplicationFolder",

	----------------------
	---- Server ----------
	----------------------

	Server = {
		-- will automatically create components from a found Component folder under the Server directory
		AutoComponentBehavior = true,
		-- will automatically init Services under a specified Service folder
		AutoServiceBehavior = true,

		-- will automatically mount ApeIntelligence behaviors
		AutoMountBehavior = true

	},

	----------------------
	---- Client ----------
	----------------------

	Client = {
		-- will automatically create components from a found Component folder under the Client directory
		AutoComponentBehavior = true,
		-- will automatically init Controllers under a specified Controller folder
		AutoControllerBehavior = true,

		-- will automatically mount ApeIntelligence behaviors
		AutoMountBehavior = true,

		EventHandlers = {
			"OnPlayerAdded",
			"OnCharacterAdded",
		}
	},

}