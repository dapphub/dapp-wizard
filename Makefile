all:
	go build github.com/dapphub/gethtool
	mv gethtool dapp/gethtool.exe
	raco link dapp
	raco exe -o dapp-ui dapp-cli.rkt
	raco distribute dist dapp-ui
	rm -f dapp/dapp-ui dapp/gethtool.exe
