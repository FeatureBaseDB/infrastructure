TAXI_MAKE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include ../../include/Makefile-pilosa-agent

taxi:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk taxi -f go/src/github.com/pilosa/pdk/usecase/taxi/greenAndYellowUrls.txt --pilosa=`echo $$(PILOSA_HOSTS) | cut -d, -f1` -b 524288 -c 12 -e 2 &> taxi.out &'

taxi-log:
	$(MAKE) ssh-agent CMD='tail -f taxi.out'

taxi-weather:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk weather -f go/src/github.com/pilosa/pdk/usecase/weather/urls.txt -p `echo $$(PILOSA_HOSTS) | cut -d, -f1` &> taxi-weather.out &'

taxi-weather-log:
	$(MAKE) ssh-agent CMD='tail -f taxi-weather.out'

halftaxi:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk taxi -f go/src/github.com/pilosa/pdk/usecase/taxi/halfURLs.txt --pilosa=`echo $$(PILOSA_HOSTS) | cut -d, -f1` -b 524288 -c 12 -e 2 &> halftaxi.out &'

halftaxi-log:
	$(MAKE) ssh-agent CMD='tail -f halftaxi.out'

fakeusers:
	$(MAKE) ssh-agent CMD='source /etc/profile && exec nohup pdk fakeusers -b 100000 -n 4000000 --pilosa-hosts=$$(PILOSA_HOSTS) &> fakeusers.out &'

RESULT_FILE=rawresults-$(CLOUD)-$(SHAPE)-$(COUNT)-$(USERNAME)-$(shell date +%Y%m%dT%H%M).csv

bench:
	scp $(TAXI_MAKE_DIR)/benchmark.sh $(USERNAME)@$(AGENT_PUBLIC_IP):
	$(MAKE) ssh-agent CMD='chmod +x ./benchmark.sh && ./benchmark.sh > /dev/null && ./benchmark.sh > benchrun.jsons'
	$(MAKE) ssh CMD='source /etc/profile && mkdir -p /home/$(USERNAME)/.pilosa/.bench && cd go/src/github.com/pilosa/pilosa && GO111MODULE=on go test -bench=. -run=NoneZ -timeout=245m -temp-dir=/home/$(USERNAME)/.pilosa/.bench' | tee ./gobenchpilosa.out
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa/roaring && go test -bench=. -run=NoneZ  -timeout=245m' |  tee ./gobenchroaring.out
	$(MAKE) ssh CMD='source /etc/profile && cd go/src/github.com/pilosa/pilosa/inmem && go test -bench=. -run=NoneZ -timeout=45m' |  tee ./gobenchinmem.out
	scp $(USERNAME)@$(AGENT_PUBLIC_IP):benchrun.jsons .
	$(MAKE) parse-go-bench
	$(MAKE) format-go-bench
	$(MAKE) format-benchruns
	echo '"Cloud","Instance Type/Shape","Cluster size","Benchmark","Mean","Min","Max","Iterations","Username"' > ${RESULT_FILE}
	cat gobench*.csv benchruns.csv >> ${RESULT_FILE}
	# Normalize Go benchmark names to remove the "-GOMAXPROCS"
	gsed -i 's/\(Benchmark.*\)-[0-9]\+",/\1",/g' ${RESULT_FILE}
	@echo ${RESULT_FILE} > .latest_run_name

PARSE_GO_BENCH=jq -R 'capture("(?<name>[^\\s]*)[\\s]+(?<iterations>\\d+)[\t ]+(?<mean>\\d+)[\\s]ns/op.*")'

parse-go-bench:
	cat gobenchpilosa.out | $(PARSE_GO_BENCH) | tee gobenchpilosa.out.jsons
	cat gobenchroaring.out | $(PARSE_GO_BENCH) | tee gobenchroaring.out.jsons
	cat gobenchinmem.out | $(PARSE_GO_BENCH) | tee gobenchinmem.out.jsons

#csv format: cloud-provider,instance-shape,cluster-size,benchmark-name/query,mean,min,max,num
FORMAT_GO_BENCH=jq -r '["$(CLOUD)", "$(SHAPE)", "$(COUNT)", .name, .mean, null, null, .iterations, "$(USERNAME)"] | @csv'

format-go-bench: check-vars
	cat gobenchpilosa.out.jsons | $(FORMAT_GO_BENCH) | tee gobenchpilosa.out.csv
	cat gobenchroaring.out.jsons | $(FORMAT_GO_BENCH) | tee gobenchroaring.out.csv
	cat gobenchinmem.out.jsons | $(FORMAT_GO_BENCH) | tee gobenchinmem.out.csv

format-benchruns: check-vars
	cat benchrun.jsons | jq -r '["$(CLOUD)", "$(SHAPE)", "$(COUNT)", .configuration.query, .stats.mean, .stats.min, .stats.max, .configuration.iterations, "$(USERNAME)"] | @csv' | tee benchruns.csv

TOKEN=$(shell cat ../data.world-api-token)


LAST_RUN=$(shell cat .latest_run_name)
upload:
	curl \
	  -H "Authorization: Bearer ${TOKEN}" \
	  -X PUT -H "Content-Type: application/octet-stream" \
	  --data-binary @${LAST_RUN} \
	  https://api.data.world/v0/uploads/jaffee/benchmarks/files/${LAST_RUN}
	@echo ""
	curl -H "Authorization: Bearer ${TOKEN}" \
	  https://api.data.world/v0/datasets/jaffee/benchmarks/sync
	@echo ""

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
	scp $(TAXI_MAKE_DIR)/halfurls.sh $(USERNAME)@$(AGENT_PUBLIC_IP):
	$(MAKE) ssh-agent CMD='chmod +x ./halfurls.sh && ./halfurls.sh'

bandwidth:
	scp $(TAXI_MAKE_DIR)/bandwidth.sh $(TAXI_MAKE_DIR)/bandwidth-list.txt $(USERNAME)@$(PILOSA_PUBLIC_IP):
	$(MAKE) ssh CMD='chmod +x ./bandwidth.sh && exec nohup ./bandwidth.sh &> bandwidth.sh.out &'

bw-results:
	scp $(USERNAME)@$(PILOSA_PUBLIC_IP):allbw.out .
	awk -F'!' '{print "\"$(CLOUD)\",\"$(SHAPE)\",$(COUNT),\"" $$1 "\"," $$2 ",,,,\"$(USERNAME)\""}' allbw.out > allbw.csv
	mv $(LAST_RUN) $(LAST_RUN).orig
	cat $(LAST_RUN).orig allbw.csv > $(LAST_RUN)

bw-log:
	$(MAKE) ssh CMD='tail -f bandwidth.sh.out'
