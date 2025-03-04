# gRPC Protocol

Remote procedure call (RPC): Extends the idea of local procedure call to a remote server. Defined framework for data encoding and communication protocol. 

Ex. Implementation of a procedure, function, etc. is on a remote server and client can call it remotely

Useful in modern web services; services are partitioned into smaller services, each with APIs. Could be REST (with JSON) or gRPC.

## gRPC

- Modern implementation of RPC
- Based on protobuffs (protocol buffers) -- can specify structure of data, then converted to binary format to serialize data for transmission
- Leverages HTTP 2 (persistent and pipelined messages)

## Using gRPC and Workflow

Create a .proto file which specifies the structure of the data and defines the functions

Compiler generates libraries of the stubs (serializing/deserializing data). Supports a number of different languages.

Create server program using libraries

Define the implementations of the functions specified in .proto

Create client program using libraries

Make calls to the functions specified in .proto

4 Types of APIs in gRPC:

- Unary
- Server streaming
- Client streaming
- Bi-directional streaming