# Honey Cat

Red Honey Cat is a simple, easy to use honey pot that sets up what looks like is a service, but is really a honey pot on a user specified port. Originally written in BASH, Red Honey Cat is the Ruby variant I wrote for YoloCon 2016. Rainbow support is also a thing because people need it, obviously.
 
## Installation
You're going to need to install the following ruby gems for rainbow powers and other functionality:  
                                                                   
`gem install lolize logger`

## Usage
Quickly Setup Honey Pot

`ruby red-honey-cat.rb -p <PORT>`

Define a Custom Banner

`ruby red-honey-cat.rb -b <BANNER>`

View Help

`ruby red-honey-cat.rb -h`

## Help Menu
`RED HONEY CAT 

Usage: red-honey-cat.rb [OPTIONS]

EX: red-honey-cat.rb -p 31337

Options: 
    -p, --port <PORT>                Define the port to start honeypot on.
    -b, --banner <BANNER>            Define a custom banner to be set for your honeypot.
    -l, --lol                        Rainbow support, because we need it.
    -v, --version                    Show verison number.
    -h, --help                       Help menu.`
---

### Credits
Kent 'picat' Gruber
