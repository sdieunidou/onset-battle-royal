local pprint = require( 'packages/' .. GetPackageName() .. '/vendor/pprint' )

local util = {}

function util.pprint( str, ... )
	util.info( str, ... )
end

function util.error( str, ... )
	print( '[\27[31merror\27[0m] ' .. tostring( str ), table.unpack( { ... } ) )
end

function util.warning( str, ... )
	print( '[\27[33mwarning\27[0m] ' .. tostring( str ), table.unpack( { ... } ) )
end

function util.success( str, ... )
	print( '[\27[32merror\27[0m] ' .. tostring( str ), table.unpack( { ... } ) )
end

function util.info( str, ... )
	print( '[\27[34minfo\27[0m] ' .. tostring( str ), table.unpack( { ... } ) )
end

return util
