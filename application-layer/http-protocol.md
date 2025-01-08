# Application Protocol: HTTP

Application-level protocols tell us how the processes should communicate (e.g., with YouTube, am I watching a video or uploading a video?). How do the processes encode the data?

The protocol defines the following:

- Message syntax: which fields, how fields are delineated
    - Receiver needs to be able to extract the same message as what the transmitter sent (presentation encoding/decoding)
    - Goal of approach: debuggability, bandwith, processing
- Types of messages exchanged: request, response
- Message semantics: meaning of information in fields

## Data Types

We may want to exchange different types of data in our network

- Base types (e.g. integer--number of bits? Order of bytes?)
- Flat types (e.g. array/structure--padding? Length?)
- Complex types (e.g. trees/linked lists with pointers--must serialize/flatten)

## Conversion Strategy

Two common strategies:

**Canonical Intermediate Form**: Sender converts its internal representation into some agreed upon format before sending; receiver converts received data (in that agreed upon format) into its internal representation.

**Receiver Makes Right**: Sender transmits data in its internal representation and includes information about representation; receiver converts from the sender's representation to its own representation if needed. Works well if assumption is a homogeneous infrastructure.

## Tagging

- Untagged: agree on type, length, and location of data
- Tagged: include in message tags about the data (type and length)

## HTTP

The web's application-layer protocol. Client/server exchange web objects (html, jpeg, audio file, etc.) Stateless: server doesn't retain information about past client requests.

HTTP message types:

- Options: request information about available options
- GET: retrieve document identified in url
- HEAD: retrieve metainformation about document identified in url
- POST: give information to server
- PUT: store document under specified url
- DELETE: delete specified url
- TRACE: loopback request message
- CONNECT: for use by proxies

HTTP data formats:

- HTML: good for describing appearance of webpage (text/html)
- JSON: good for passing info (APIs) (application/json)
    - Data in name-value pairs: key (string), value (any type; string, number, object, array, boolean, null, etc.)