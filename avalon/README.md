# Avalon x Whishbone

## Signals

This section describes the signals used in the Avalon and Wishbone protocols.

### Avalon

| Signal | Description |
| ------ | ----------- |
| `clk` | Clock signal |
| `reset` | Reset signal |
| `read` | Read signal |
| `write` | Write signal |
| `address` | Address signal |
| `writedata` | Write data signal |
| `readdata` | Read data signal |
| `waitrequest` | Wait request signal |
| `response` | Response signal |
| `readdatavalid` | Read data valid signal |
| `burstcount` | Burst count signal |

### Wishbone

| Signal | Description |
| ------ | ----------- |
| `clk` | Clock signal |
| `rst` | Reset signal |
| `cyc` | Cycle signal |
| `stb` | Strobe signal |
| `we` | Write enable signal |
| `adr` | Address signal |
| `dat_i` | Input Data signal |
| `dat_o` | Output Data signal |
| `ack` | Acknowledge signal |
| `err` | Error signal |
| `sel` | Select bytes |
| `cti` | Cycle type |
| `bte` | Burst type |

### Comments

Making a quick comparison between the two protocols, we can see that there are some differences between them, but also some similarities. Firstly, the Avalon protocol has three signals of control: `read`, `write` and `waitrequest`. The signals `read` and `write` are used to indicate the type of transaction, while the Whishbone uses the same signal (`we`) to indicate whether the transaction is a read access or a write access. Since the Wishbone protocol uses the same signal to indicate the type of transaction, it is necessary to use the signals `cyc` and `stb` to indicate the beginning of the transaction. The `cyc` signal is used to indicate that the transaction is active, while the `stb` signal is used to indicate that the transaction is valid. The signal `waitrequest` is used to indicate that the slave is not ready to accept a new transaction and forces the host to wait until the interconnect is ready to proceed with the transfer. The Wishbone protocol does not have a signal similar to `waitrequest`, it only has response signals.  

The signal `response` from Avalon is used by the slave to indicate the status of the transaction. The Whishbone protocol uses two signals to indicate the status of the transaction: `ack` and `err`. The signal `ack` is used to indicate that the transaction was successful, while the signal `err` is used to indicate that the transaction was not successful.

The signals `writedata` and `readdata` are used to indicate the data to be written and read, respectively. They are similar to the signals `dat_i` and `dat_o` of the Wishbone protocol.

Another difference between the two protocols is the signal `sel`. The signal `sel` is used to indicate where valid data is expected on the `dat_i` signal when is a read access or on the `dat_o` when is a write access, while the Avalon protocol does not have a similar signal.

## Handshake

This section describes the handshake used in the Avalon and Wishbone protocols.

### Avalon

The handshake in the Avalon protocols is done by the following steps:

1. The master asserts the `read` or `write` signal and the `address` signal.
2. The slave asserts the `waitrequest` signal if it is not ready to accept the transaction.
3. The master waits until the slave is ready to accept the transaction.
4. The master asserts the `writedata` signal if it is a write access.
5. The slave asserts the `response` signal to indicate the status of the transaction.

### Whishbone

The handshake in the Wishbone protocol is done by the following steps:

1. The master asserts the `cyc` signal.
2. The master asserts the `stb`, `we`, `adr` and `sel` signals.
3. The master asserts its `dat_o` signal if it is a write access.
4. The slave asserts the `ack` signal to indicate that the transaction was successful or the `err` signal to indicate that the transaction was not successful.

### Comments

The Avalon protocol has a more complex handshake than the Whishbone protocol. By using the `waitrequest` signal, the slave can indicate that it is not ready to accept the transaction, forcing the master to wait until the slave is ready. The Whishbone protocol does not have this behavior, the master does the request and must wait the response from the slave through the `ack` or `err` signals to proceed with new accesses.

## Types of Transactions

This section describes the types of transactions used in the Avalon and Wishbone protocols.

### Avalon

Besides the simple transaction as described in the previous section, the Avalon protocol has two other types of transactions: Pipelined Transfers and Burst Transfers. 

#### Pipelined Transfers

The host can start a new transaction before the previous transaction is completed. The host must wait for the `readdatavalid` signal to be asserted before reading the data. When the `readdatavalid` signal is asserted, the `readdata` signal contains the data in sequence according to the addresses sent by the host.

#### Burst Transfers

The host can start a burst transfer by asserting the `burstcount` signal. As in the Pipelined Transfers, in the Burst Transfers the host must wait for the `readdatavalid` signal to be asserted before reading the data. When the `readdatavalid` signal is asserted, the `readdata` signal contains the data in sequence according to the addresses sent by the host. The `burstcount` signal is used to indicate the number of data to be transferred in sequence according to the addresses sent by the host. Even in a burst transfer, if the host is doing a write access, the `waitrequest` signal can be used by the agent.

### Wishbone

Differently from the Avalon protocol, the Whishbone has only one type of transaction besides the simple one, it is the Burst. The Burst transaction is similar to the Burst Transfers of the Avalon protocol. It is used to read a sequence of data in sequence according to the addresses sent by the host. 

The `cti` signal is used to indicate the type of transaction. The `cti` signal can have the following values:

- `b000` - **Single access:** simple transaction
- `b001` - **Constant address burst cycle:** A constant address burst is defined as a single cycle with multiple accesses to the same address
- `b010` - **Incrementing burst cycle:** An incrementing burst is defined as multiple accesses to consecutive addresses
- `b111` - **End of burst**
- Other values - **Reserved**

The `bte` signal is used to indicate the number of data to be transferred in sequence according to the addresses sent by the host. Once the transaction is valid, the slave asserts the `ack` signal until the end of the burst.