DefaultNetworkHandler = DefaultNetworkHandler or class()

-- Lines 3-4
function DefaultNetworkHandler:init()
end

-- Lines 6-14
function DefaultNetworkHandler.lost_peer(peer_ip)
	cat_print("multiplayer_base", "Lost Peer (DefaultNetworkHandler)")

	if managers.network:session() then
		local peer = managers.network:session():peer_by_ip(peer_ip:ip_at_index(0))

		if peer then
			managers.network:session():on_peer_lost(peer, peer:id())
		end
	end
end

-- Lines 15-23
function DefaultNetworkHandler.lost_client(peer_ip)
	Application:error("[DefaultNetworkHandler] Lost client", peer_ip)

	if managers.network:session() then
		local peer = managers.network:session():peer_by_ip(peer_ip:ip_at_index(0))

		if peer then
			managers.network:session():on_peer_lost(peer, peer:id())
		end
	end
end

-- Lines 24-32
function DefaultNetworkHandler.lost_server(peer_ip)
	Application:error("[DefaultNetworkHandler] Lost server", peer_ip)

	if managers.network:session() then
		local peer = managers.network:session():peer_by_ip(peer_ip:ip_at_index(0))

		if peer then
			managers.network:session():on_peer_lost(peer, peer:id())
		end
	end
end
