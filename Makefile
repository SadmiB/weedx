proto:
	protoc --elixir_out=plugins=grpc:./lib/weedx/ lib/proto/filer.proto
	mv ./lib/weedx/lib/proto/* ./lib/weedx/
	rm -rf ./lib/weedx/lib

run:
	iex -S mix