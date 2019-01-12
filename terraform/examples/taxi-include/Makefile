taxi:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk taxi -f go/src/github.com/pilosa/pdk/usecase/taxi/greenAndYellowUrls.txt --pilosa=`echo $$(PILOSA_HOSTS) | cut -d, -f1` -b 524288 -c 12 -e 2 &> taxi.out &'

halftaxi:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk taxi -f go/src/github.com/pilosa/pdk/usecase/taxi/halfURLs.txt --pilosa=`echo $$(PILOSA_HOSTS) | cut -d, -f1` -b 524288 -c 12 -e 2 &> halftaxi.out &'

fakeusers:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk fakeusers -b 100000 -n 4000000 --pilosa-hosts=$$(PILOSA_HOSTS) &> fakeusers.out &'

taxi-log:
	$(MAKE) ssh-agent CMD='tail taxi.out'

halftaxi-log:
	$(MAKE) ssh-agent CMD='tail halftaxi.out'

TAXI_MAKE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

bench:
	scp $(TAXI_MAKE_DIR)/benchmark.sh ubuntu@$(AGENT_PUBLIC_IP):
	$(MAKE) ssh-agent CMD='chmod +x ./benchmark.sh && ./benchmark.sh > benchrun.jsons'
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa && go test -bench=. -run=NoneZ -timeout=45m' | tee ./gobenchpilosa.out
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa/roaring && go test -bench=. -run=NoneZ  -timeout=45m' |  tee ./gobenchroaring.out
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa/inmem && go test -bench=. -run=NoneZ -timeout=45m' |  tee ./gobenchinmem.out
	scp ubuntu@$(AGENT_PUBLIC_IP):benchrun.jsons .
	$(MAKE) parse-go-bench
	$(MAKE) format-go-bench
	$(MAKE) format-benchruns
	cat gobench*.csv benchruns.csv > results.csv

nuke-pilosa:
	$(MAKE) run CMD="sudo service pilosa stop; rm -rf ./.pilosa/*; sudo service pilosa start"

restart-pilosa:
	$(MAKE) run CMD="sudo service pilosa restart"

PARSE_GO_BENCH=jq -R 'capture("(?<name>[^\\s]*)[\\s]+(?<iterations>\\d+)[\t ]+(?<mean>\\d+)[\\s]ns/op.*")'

parse-go-bench:
	cat gobenchpilosa.out | $(PARSE_GO_BENCH) | tee gobenchpilosa.out.jsons
	cat gobenchroaring.out | $(PARSE_GO_BENCH) | tee gobenchroaring.out.jsons
	cat gobenchinmem.out | $(PARSE_GO_BENCH) | tee gobenchinmem.out.jsons

#csv format: cloud-provider,instance-shape,cluster-size,benchmark-name/query,mean,min,max,num
FORMAT_GO_BENCH=jq -r '["$(CLOUD)", "$(SHAPE)", "$(COUNT)", .name, .mean, null, null, .iterations] | @csv'

format-go-bench: check-vars
	cat gobenchpilosa.out.jsons | $(FORMAT_GO_BENCH) | tee gobenchpilosa.out.csv
	cat gobenchroaring.out.jsons | $(FORMAT_GO_BENCH) | tee gobenchroaring.out.csv
	cat gobenchinmem.out.jsons | $(FORMAT_GO_BENCH) | tee gobenchinmem.out.csv

format-benchruns: check-vars
	cat benchrun.jsons | jq -r '["$(CLOUD)", "$(SHAPE)", "$(COUNT)", .configuration.query, .stats.mean, .stats.min, .stats.max, .configuration.iterations] | @csv' | tee benchruns.csv

check-vars:
	$(call check_defined, CLOUD, Cloud provider, e.g. AWS, OCI, or Azure)
	$(call check_defined, SHAPE, Instance shape/type)
	$(call check_defined, COUNT, Number of Pilosa nodes)

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

halfurls:
	scp $(TAXI_MAKE_DIR)/halfurls.sh ubuntu@$(AGENT_PUBLIC_IP):
	$(MAKE) ssh-agent CMD='chmod +x ./halfurls.sh && ./halfurls.sh'
