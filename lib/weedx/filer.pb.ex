defmodule Weedx.Filer.LookupDirectoryEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:name, 2, type: :string)
end

defmodule Weedx.Filer.LookupDirectoryEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:entry, 1, type: Weedx.Filer.Entry)
end

defmodule Weedx.Filer.ListEntriesRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:prefix, 2, type: :string)
  field(:startFromFileName, 3, type: :string)
  field(:inclusiveStartFrom, 4, type: :bool)
  field(:limit, 5, type: :uint32)
end

defmodule Weedx.Filer.ListEntriesResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:entry, 1, type: Weedx.Filer.Entry)
end

defmodule Weedx.Filer.RemoteEntry do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:storage_name, 1, type: :string, json_name: "storageName")
  field(:last_local_sync_ts_ns, 2, type: :int64, json_name: "lastLocalSyncTsNs")
  field(:remote_e_tag, 3, type: :string, json_name: "remoteETag")
  field(:remote_mtime, 4, type: :int64, json_name: "remoteMtime")
  field(:remote_size, 5, type: :int64, json_name: "remoteSize")
end

defmodule Weedx.Filer.Entry.ExtendedEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: :bytes)
end

defmodule Weedx.Filer.Entry do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:is_directory, 2, type: :bool, json_name: "isDirectory")
  field(:chunks, 3, repeated: true, type: Weedx.Filer.FileChunk)
  field(:attributes, 4, type: Weedx.Filer.FuseAttributes)
  field(:extended, 5, repeated: true, type: Weedx.Filer.Entry.ExtendedEntry, map: true)
  field(:hard_link_id, 7, type: :bytes, json_name: "hardLinkId")
  field(:hard_link_counter, 8, type: :int32, json_name: "hardLinkCounter")
  field(:content, 9, type: :bytes)
  field(:remote_entry, 10, type: Weedx.Filer.RemoteEntry, json_name: "remoteEntry")
  field(:quota, 11, type: :int64)
end

defmodule Weedx.Filer.FullEntry do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:dir, 1, type: :string)
  field(:entry, 2, type: Weedx.Filer.Entry)
end

defmodule Weedx.Filer.EventNotification do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:old_entry, 1, type: Weedx.Filer.Entry, json_name: "oldEntry")
  field(:new_entry, 2, type: Weedx.Filer.Entry, json_name: "newEntry")
  field(:delete_chunks, 3, type: :bool, json_name: "deleteChunks")
  field(:new_parent_path, 4, type: :string, json_name: "newParentPath")
  field(:is_from_other_cluster, 5, type: :bool, json_name: "isFromOtherCluster")
  field(:signatures, 6, repeated: true, type: :int32)
end

defmodule Weedx.Filer.FileChunk do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:file_id, 1, type: :string, json_name: "fileId")
  field(:offset, 2, type: :int64)
  field(:size, 3, type: :uint64)
  field(:mtime, 4, type: :int64)
  field(:e_tag, 5, type: :string, json_name: "eTag")
  field(:source_file_id, 6, type: :string, json_name: "sourceFileId")
  field(:fid, 7, type: Weedx.Filer.FileId)
  field(:source_fid, 8, type: Weedx.Filer.FileId, json_name: "sourceFid")
  field(:cipher_key, 9, type: :bytes, json_name: "cipherKey")
  field(:is_compressed, 10, type: :bool, json_name: "isCompressed")
  field(:is_chunk_manifest, 11, type: :bool, json_name: "isChunkManifest")
end

defmodule Weedx.Filer.FileChunkManifest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:chunks, 1, repeated: true, type: Weedx.Filer.FileChunk)
end

defmodule Weedx.Filer.FileId do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:volume_id, 1, type: :uint32, json_name: "volumeId")
  field(:file_key, 2, type: :uint64, json_name: "fileKey")
  field(:cookie, 3, type: :fixed32)
end

defmodule Weedx.Filer.FuseAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:file_size, 1, type: :uint64, json_name: "fileSize")
  field(:mtime, 2, type: :int64)
  field(:file_mode, 3, type: :uint32, json_name: "fileMode")
  field(:uid, 4, type: :uint32)
  field(:gid, 5, type: :uint32)
  field(:crtime, 6, type: :int64)
  field(:mime, 7, type: :string)
  field(:replication, 8, type: :string)
  field(:collection, 9, type: :string)
  field(:ttl_sec, 10, type: :int32, json_name: "ttlSec")
  field(:user_name, 11, type: :string, json_name: "userName")
  field(:group_name, 12, repeated: true, type: :string, json_name: "groupName")
  field(:symlink_target, 13, type: :string, json_name: "symlinkTarget")
  field(:md5, 14, type: :bytes)
  field(:disk_type, 15, type: :string, json_name: "diskType")
  field(:rdev, 16, type: :uint32)
  field(:inode, 17, type: :uint64)
end

defmodule Weedx.Filer.CreateEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:entry, 2, type: Weedx.Filer.Entry)
  field(:o_excl, 3, type: :bool, json_name: "oExcl")
  field(:is_from_other_cluster, 4, type: :bool, json_name: "isFromOtherCluster")
  field(:signatures, 5, repeated: true, type: :int32)
  field(:skip_check_parent_directory, 6, type: :bool, json_name: "skipCheckParentDirectory")
end

defmodule Weedx.Filer.CreateEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:error, 1, type: :string)
end

defmodule Weedx.Filer.UpdateEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:entry, 2, type: Weedx.Filer.Entry)
  field(:is_from_other_cluster, 3, type: :bool, json_name: "isFromOtherCluster")
  field(:signatures, 4, repeated: true, type: :int32)
end

defmodule Weedx.Filer.UpdateEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Weedx.Filer.AppendToEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:entry_name, 2, type: :string, json_name: "entryName")
  field(:chunks, 3, repeated: true, type: Weedx.Filer.FileChunk)
end

defmodule Weedx.Filer.AppendToEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Weedx.Filer.DeleteEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:name, 2, type: :string)
  field(:is_delete_data, 4, type: :bool, json_name: "isDeleteData")
  field(:is_recursive, 5, type: :bool, json_name: "isRecursive")
  field(:ignore_recursive_error, 6, type: :bool, json_name: "ignoreRecursiveError")
  field(:is_from_other_cluster, 7, type: :bool, json_name: "isFromOtherCluster")
  field(:signatures, 8, repeated: true, type: :int32)
end

defmodule Weedx.Filer.DeleteEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:error, 1, type: :string)
end

defmodule Weedx.Filer.AtomicRenameEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:old_directory, 1, type: :string, json_name: "oldDirectory")
  field(:old_name, 2, type: :string, json_name: "oldName")
  field(:new_directory, 3, type: :string, json_name: "newDirectory")
  field(:new_name, 4, type: :string, json_name: "newName")
  field(:signatures, 5, repeated: true, type: :int32)
end

defmodule Weedx.Filer.AtomicRenameEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Weedx.Filer.StreamRenameEntryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:old_directory, 1, type: :string, json_name: "oldDirectory")
  field(:old_name, 2, type: :string, json_name: "oldName")
  field(:new_directory, 3, type: :string, json_name: "newDirectory")
  field(:new_name, 4, type: :string, json_name: "newName")
  field(:signatures, 5, repeated: true, type: :int32)
end

defmodule Weedx.Filer.StreamRenameEntryResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)

  field(:event_notification, 2,
    type: Weedx.Filer.EventNotification,
    json_name: "eventNotification"
  )

  field(:ts_ns, 3, type: :int64, json_name: "tsNs")
end

defmodule Weedx.Filer.AssignVolumeRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:count, 1, type: :int32)
  field(:collection, 2, type: :string)
  field(:replication, 3, type: :string)
  field(:ttl_sec, 4, type: :int32, json_name: "ttlSec")
  field(:data_center, 5, type: :string, json_name: "dataCenter")
  field(:path, 6, type: :string)
  field(:rack, 7, type: :string)
  field(:data_node, 9, type: :string, json_name: "dataNode")
  field(:disk_type, 8, type: :string, json_name: "diskType")
end

defmodule Weedx.Filer.AssignVolumeResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:file_id, 1, type: :string, json_name: "fileId")
  field(:count, 4, type: :int32)
  field(:auth, 5, type: :string)
  field(:collection, 6, type: :string)
  field(:replication, 7, type: :string)
  field(:error, 8, type: :string)
  field(:location, 9, type: Weedx.Filer.Location)
end

defmodule Weedx.Filer.LookupVolumeRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:volume_ids, 1, repeated: true, type: :string, json_name: "volumeIds")
end

defmodule Weedx.Filer.Locations do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:locations, 1, repeated: true, type: Weedx.Filer.Location)
end

defmodule Weedx.Filer.Location do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:url, 1, type: :string)
  field(:public_url, 2, type: :string, json_name: "publicUrl")
  field(:grpc_port, 3, type: :uint32, json_name: "grpcPort")
end

defmodule Weedx.Filer.LookupVolumeResponse.LocationsMapEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: Weedx.Filer.Locations)
end

defmodule Weedx.Filer.LookupVolumeResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:locations_map, 1,
    repeated: true,
    type: Weedx.Filer.LookupVolumeResponse.LocationsMapEntry,
    json_name: "locationsMap",
    map: true
  )
end

defmodule Weedx.Filer.Collection do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:name, 1, type: :string)
end

defmodule Weedx.Filer.CollectionListRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:include_normal_volumes, 1, type: :bool, json_name: "includeNormalVolumes")
  field(:include_ec_volumes, 2, type: :bool, json_name: "includeEcVolumes")
end

defmodule Weedx.Filer.CollectionListResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:collections, 1, repeated: true, type: Weedx.Filer.Collection)
end

defmodule Weedx.Filer.DeleteCollectionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:collection, 1, type: :string)
end

defmodule Weedx.Filer.DeleteCollectionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Weedx.Filer.StatisticsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:replication, 1, type: :string)
  field(:collection, 2, type: :string)
  field(:ttl, 3, type: :string)
  field(:disk_type, 4, type: :string, json_name: "diskType")
end

defmodule Weedx.Filer.StatisticsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:total_size, 4, type: :uint64, json_name: "totalSize")
  field(:used_size, 5, type: :uint64, json_name: "usedSize")
  field(:file_count, 6, type: :uint64, json_name: "fileCount")
end

defmodule Weedx.Filer.GetFilerConfigurationRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Weedx.Filer.GetFilerConfigurationResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:masters, 1, repeated: true, type: :string)
  field(:replication, 2, type: :string)
  field(:collection, 3, type: :string)
  field(:max_mb, 4, type: :uint32, json_name: "maxMb")
  field(:dir_buckets, 5, type: :string, json_name: "dirBuckets")
  field(:cipher, 7, type: :bool)
  field(:signature, 8, type: :int32)
  field(:metrics_address, 9, type: :string, json_name: "metricsAddress")
  field(:metrics_interval_sec, 10, type: :int32, json_name: "metricsIntervalSec")
  field(:version, 11, type: :string)
  field(:cluster_id, 12, type: :string, json_name: "clusterId")
end

defmodule Weedx.Filer.SubscribeMetadataRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:client_name, 1, type: :string, json_name: "clientName")
  field(:path_prefix, 2, type: :string, json_name: "pathPrefix")
  field(:since_ns, 3, type: :int64, json_name: "sinceNs")
  field(:signature, 4, type: :int32)
  field(:path_prefixes, 6, repeated: true, type: :string, json_name: "pathPrefixes")
  field(:client_id, 7, type: :int32, json_name: "clientId")
end

defmodule Weedx.Filer.SubscribeMetadataResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)

  field(:event_notification, 2,
    type: Weedx.Filer.EventNotification,
    json_name: "eventNotification"
  )

  field(:ts_ns, 3, type: :int64, json_name: "tsNs")
end

defmodule Weedx.Filer.LogEntry do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:ts_ns, 1, type: :int64, json_name: "tsNs")
  field(:partition_key_hash, 2, type: :int32, json_name: "partitionKeyHash")
  field(:data, 3, type: :bytes)
end

defmodule Weedx.Filer.KeepConnectedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:grpc_port, 2, type: :uint32, json_name: "grpcPort")
  field(:resources, 3, repeated: true, type: :string)
end

defmodule Weedx.Filer.KeepConnectedResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Weedx.Filer.LocateBrokerRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:resource, 1, type: :string)
end

defmodule Weedx.Filer.LocateBrokerResponse.Resource do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:grpc_addresses, 1, type: :string, json_name: "grpcAddresses")
  field(:resource_count, 2, type: :int32, json_name: "resourceCount")
end

defmodule Weedx.Filer.LocateBrokerResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:found, 1, type: :bool)
  field(:resources, 2, repeated: true, type: Weedx.Filer.LocateBrokerResponse.Resource)
end

defmodule Weedx.Filer.KvGetRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:key, 1, type: :bytes)
end

defmodule Weedx.Filer.KvGetResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:value, 1, type: :bytes)
  field(:error, 2, type: :string)
end

defmodule Weedx.Filer.KvPutRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:key, 1, type: :bytes)
  field(:value, 2, type: :bytes)
end

defmodule Weedx.Filer.KvPutResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:error, 1, type: :string)
end

defmodule Weedx.Filer.FilerConf.PathConf do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:location_prefix, 1, type: :string, json_name: "locationPrefix")
  field(:collection, 2, type: :string)
  field(:replication, 3, type: :string)
  field(:ttl, 4, type: :string)
  field(:disk_type, 5, type: :string, json_name: "diskType")
  field(:fsync, 6, type: :bool)
  field(:volume_growth_count, 7, type: :uint32, json_name: "volumeGrowthCount")
  field(:read_only, 8, type: :bool, json_name: "readOnly")
  field(:data_center, 9, type: :string, json_name: "dataCenter")
  field(:rack, 10, type: :string)
  field(:data_node, 11, type: :string, json_name: "dataNode")
end

defmodule Weedx.Filer.FilerConf do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:version, 1, type: :int32)
  field(:locations, 2, repeated: true, type: Weedx.Filer.FilerConf.PathConf)
end

defmodule Weedx.Filer.CacheRemoteObjectToLocalClusterRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:directory, 1, type: :string)
  field(:name, 2, type: :string)
end

defmodule Weedx.Filer.CacheRemoteObjectToLocalClusterResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field(:entry, 1, type: Weedx.Filer.Entry)
end

defmodule Weedx.Filer.SeaweedFiler.Service do
  @moduledoc false
  use GRPC.Service, name: "weedx.filer.SeaweedFiler", protoc_gen_elixir_version: "0.10.0"

  rpc(
    :LookupDirectoryEntry,
    Weedx.Filer.LookupDirectoryEntryRequest,
    Weedx.Filer.LookupDirectoryEntryResponse
  )

  rpc(:ListEntries, Weedx.Filer.ListEntriesRequest, stream(Weedx.Filer.ListEntriesResponse))

  rpc(:CreateEntry, Weedx.Filer.CreateEntryRequest, Weedx.Filer.CreateEntryResponse)

  rpc(:UpdateEntry, Weedx.Filer.UpdateEntryRequest, Weedx.Filer.UpdateEntryResponse)

  rpc(:AppendToEntry, Weedx.Filer.AppendToEntryRequest, Weedx.Filer.AppendToEntryResponse)

  rpc(:DeleteEntry, Weedx.Filer.DeleteEntryRequest, Weedx.Filer.DeleteEntryResponse)

  rpc(
    :AtomicRenameEntry,
    Weedx.Filer.AtomicRenameEntryRequest,
    Weedx.Filer.AtomicRenameEntryResponse
  )

  rpc(
    :StreamRenameEntry,
    Weedx.Filer.StreamRenameEntryRequest,
    stream(Weedx.Filer.StreamRenameEntryResponse)
  )

  rpc(:AssignVolume, Weedx.Filer.AssignVolumeRequest, Weedx.Filer.AssignVolumeResponse)

  rpc(:LookupVolume, Weedx.Filer.LookupVolumeRequest, Weedx.Filer.LookupVolumeResponse)

  rpc(:CollectionList, Weedx.Filer.CollectionListRequest, Weedx.Filer.CollectionListResponse)

  rpc(
    :DeleteCollection,
    Weedx.Filer.DeleteCollectionRequest,
    Weedx.Filer.DeleteCollectionResponse
  )

  rpc(:Statistics, Weedx.Filer.StatisticsRequest, Weedx.Filer.StatisticsResponse)

  rpc(
    :GetFilerConfiguration,
    Weedx.Filer.GetFilerConfigurationRequest,
    Weedx.Filer.GetFilerConfigurationResponse
  )

  rpc(
    :SubscribeMetadata,
    Weedx.Filer.SubscribeMetadataRequest,
    stream(Weedx.Filer.SubscribeMetadataResponse)
  )

  rpc(
    :SubscribeLocalMetadata,
    Weedx.Filer.SubscribeMetadataRequest,
    stream(Weedx.Filer.SubscribeMetadataResponse)
  )

  rpc(
    :KeepConnected,
    stream(Weedx.Filer.KeepConnectedRequest),
    stream(Weedx.Filer.KeepConnectedResponse)
  )

  rpc(:LocateBroker, Weedx.Filer.LocateBrokerRequest, Weedx.Filer.LocateBrokerResponse)

  rpc(:KvGet, Weedx.Filer.KvGetRequest, Weedx.Filer.KvGetResponse)

  rpc(:KvPut, Weedx.Filer.KvPutRequest, Weedx.Filer.KvPutResponse)

  rpc(
    :CacheRemoteObjectToLocalCluster,
    Weedx.Filer.CacheRemoteObjectToLocalClusterRequest,
    Weedx.Filer.CacheRemoteObjectToLocalClusterResponse
  )
end

defmodule Weedx.Filer.SeaweedFiler.Stub do
  @moduledoc false
  use GRPC.Stub, service: Weedx.Filer.SeaweedFiler.Service
end
