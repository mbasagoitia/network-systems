# Error Handling

**Parity** is a limited form of error checking that forces every transmission to have an even (or odd) number of 1s by adding one extra bit set to 0 or 1 based on the number of 1s in the data. That way, if a single bit gets flipped, we can detect if there is an error in the data.

- Even parity
- Odd parity

We can count 1s i the data using the xor operation. 0 indicates even and 1 indicates odd.

We then add an extra bit to the end of the transmission (0 if even number of 1s, 1 if odd number of 1s in **even parity**). Opposite if **odd parity.**

Now, when receiving the data, we count number of 1s again (including the bit we added) using xor operation. We should get a 0 if using even parity.

## Cyclic Redundancy Check (CRC)

CRC is a more powerful form of error detection, adopted for FCS field in ethernet.

### CRC Calculation

Detects any 1 bit error, any two adjacent 1 bit errors, any odd number of 1 bit errors, and any burst of errors with a length of 32 or less. Simple calculation involving xor.

Transmit d data bits plus r CRC bits; R is calculated

Given:

- D: Data to be transmitted
- G: Generator polynomial (value defined by ethernet standard) (r + 1 bits)

Calculate:

- R, where <D, R> is what will be transmitted such that<D, R> is divisible by G (mod 2)
- <D, R> = D*2^r XOR R

Steps to calculate R:

1. Set R = 0.
    - This means <D, R> is currently the D bit string with r 0s added to the end
2. Divide <D, R> by G, which is also a bit string. We can do this with xor operation.
    - Quotient bit = 1 if divisor can "fit", otherwise 0
    - The remainder of this entire operation is R

Check:

- Receiver divides <D, R> by G using same operation as above. If remainder is 0, no error. Otherwise, error.