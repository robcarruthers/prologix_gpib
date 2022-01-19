Hello Rob,

NetFinder uses UDP broadcast to locate and configure GPIB-ETH controllers on a network.
You can find an implementation of the protocol in the nfcli utility
http://prologix.biz/downloads/nfcli.tar.gz

Discovery

Create NF_IDENTIFY packet.
Set sequence to a random value
Set eth_addr to all ones
Broadcast NF_IDENTIFY datagram to port 3040/UDP.
Listen for NF_IDENTIFY_REPLY datagrams.
Verify sequence matches NF_IDENTIFY packet

Configuration

Create NF*ASSIGNMENT packet
Set sequence to a random value
Set eth_addr to MAC address of desired device Set ip_type to NF_IP_DYNAMIC or NF_IP_STATIC If ip_type is NF_IP_DYNAMIC specify ip, mask and gateway addresses.
Broadcast NF* ASSIGNMENT datagram to port 3040/UDP.
Listen for NF_ASSIGNMENT_REPLY datagrams.
Verify sequence matches that of NF_ASSIGNMENT packet Check result field for NF_SUCCESS

Notes:

1. You may get multiple replies. Discard duplicate replies.
2. All multi-byte values are in network order (big-endian)
3. On multi-homed hosts, make sure broadcasts go out over all interfaces.
4. NetFinder protocol only works within the same subnet as routers will not forward UDP broadcast packets.
