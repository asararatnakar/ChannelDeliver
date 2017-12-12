## ChannelDeliver
Steps to test Channel Deliver service using fabric orderer deliver client 


### Step 0: Clone fabric repo
```
git clone https://github.com/hyperledger/fabric
```
**OR**
```
git clone git clone https://gerrit.hyperledger.org/r/fabric
```
**OR**
```
git clone ssh://<LFID>@gerrit.hyperledger.org:29418/fabric && scp -p -P 29418 <LFID>@gerrit.hyperledger.org:hooks/commit-msg fabric/.git/hooks/
```

### & Generate the images

```
cd fabric
make clean-all docker release
```
=> Make sure all th images are genearated.

### Step 1 : Generate the deliver client 
```
cd fabric/orderer/sample_clients/deliver_stdout
go build
```

### Step 2 :  Make sure to update the orderer.yaml file  (Deliver client loads the msp and mspID from there)

**fabric/sampleconfig/orderer.yaml**

```
    LocalMSPDir: ../examples/e2e_cli/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp
    LocalMSPID: Org1MSP
```

### Step 3 : Run e2e_cli sample
```
./network_setup.sh restart mychannel
```

### Step 4 :  Connect Deliver client to the peer to obtain the blocks

```
./deliver_stdout -channelID mychannel -quiet
```

Various other options

* ./deliver_stdout -channelID mychannel -quiet -server 127.0.0.1:7051
* ./deliver_stdout -channelID mychannel -quiet -server -seek <-2|-1|0|(1..N)>
* ./deliver_stdout -channelID mychannel -seek 2 >& block.json
 
**NOTE :** TLS is **DISABLED** both on Client/ Network

* Can run different tests by changing the e2e_cli sample
  --> Create multiple channels 
  (change generateArtifacts.sh file to include `$CONFIGTXGEN -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel1.tx -channelID ${CHANNEL_NAME}"1"`
  --> Donot join all the peers in the script and join at later point
  --> Send Invokes concurrently etc.,
* Generate multiple client to listen on multiple channels
