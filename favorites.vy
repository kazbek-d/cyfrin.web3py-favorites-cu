# pragma version ^0.4.0
# @license MIT


# favorite things list:
# favorite numbers
# favorite people with their favorite number

my_favorite_number: public(uint256)
list_of_numbers: public(uint256[5])


# Reference data types:
# - Fixed sized list
nums: public(uint256[10])
# - Dynamic arrays
# - Mappings 
myMap: public(HashMap[address,uint256])
mapOfPersons: public(HashMap[String[10], Person])
# - Structs
struct Person:
    name: String[10]
    age: uint256
person: public(Person)

@deploy
def __init__():
    self.my_favorite_number = 7
    self.nums[0] = 1
    self.myMap[msg.sender] = 2

    # update in state
    self.person.name = "vyper"
    self.person.age = 33

    # update in memory, state is the same
    p: Person = self.person
    p.name = "solidity"
    p.age = 22

# @internal
@external
def store(new_number: uint256):
    self.my_favorite_number = new_number

@external
@view
def retreive() -> uint256:
    return self.my_favorite_number

@external
def add_number(index: uint8, number: uint256):
    self.list_of_numbers[index] = number

@external
def add_person(name: String[10], age: uint256):
    self.mapOfPersons[name] = Person(name = name, age = age)
