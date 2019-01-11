taxi:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk taxi -f go/src/github.com/pilosa/pdk/usecase/taxi/greenAndYellowUrls.txt --pilosa=`echo $$(PILOSA_HOSTS) | cut -d, -f1` -b 2097152 -c 12 -e 2 &> taxi.out &'

taxi-log:
	$(MAKE) ssh-agent CMD='tail taxi.out'


bench:
	scp benchmark.sh ubuntu@$(AGENT_PUBLIC_IP):
	$(MAKE) ssh-agent CMD='chmod +x ./benchmark.sh && ./benchmark.sh > benchrun.jsons'
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa && go test -bench=. -run=NoneZ -timeout=45m' | tee ./gobenchpilosa.out
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa/roaring && go test -bench=. -run=NoneZ  -timeout=45m' |  tee ./gobenchroaring.out
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa/inmem && go test -bench=. -run=NoneZ -timeout=45m' |  tee ./gobenchinmem.out
	scp ubuntu@$(AGENT_PUBLIC_IP):benchrun.jsons .

