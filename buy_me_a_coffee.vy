# pragma version 0.4.1
"""
@license MIT 
@title Buy Me A Coffee!
@author Kazbek DZARASOV!
@notice This contract is for creating a sample funding contract
"""




# https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&networkType=testnet&search=&testnetSearch=
#     Network: Ethereum Testnet
#     Aggregator: ETH/USD
#     Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
#      
# https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&network=zksync&networkType=testnet&search=&testnetSearch=
#     Network: ZKsync Sepolia testnet
#     Aggregator: ETH/USD
#     Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
#import interfaces.AggregatorV3Interface as AggregatorV3Interface
# We'll learn a new way to do interfaces later...
interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

# Constants & Immutibles
PRICE_FEED: immutable(AggregatorV3Interface)
OWNER_ADDRESS: public(immutable(address))
E_10: constant(uint256) = 10 ** 10
E_18: constant(uint256) = 10 ** 18
MINIMUM_USD: public(constant(uint256)) = 5 * E_18

# Storage
funders: public(DynArray[address, 1000])
funder_to_amount_funded: public(HashMap[address, uint256])

@deploy
def __init__(PRICE_FEED_address: address):
    OWNER_ADDRESS = msg.sender
    PRICE_FEED = AggregatorV3Interface(PRICE_FEED_address)


@internal
@view
def _get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    # PRICE_FEED: 8 decimals places
    price: int256 = staticcall PRICE_FEED.latestAnswer()
    # eth_amount: 18 decimals places
    eth_price: uint256 = convert(price, uint256) * E_10
    eth_amount_in_usd: uint256 = (eth_price * eth_amount) // E_18
    return eth_amount_in_usd


@external
@view
def get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    return self._get_eth_to_usd_rate(eth_amount)


@external
@payable
def fund():
    """
    Allows users to send $ to this contract.
    Have a minimum $ amount send
    """
    usd_value_of_eth: uint256 = self._get_eth_to_usd_rate(msg.value)
    assert usd_value_of_eth >= MINIMUM_USD, "You must spend more USD!" 
    self.funders.append(msg.sender)
    self.funder_to_amount_funded[msg.sender] += msg.value

@external
@nonreentrant
def withdraw():
    """
    Withdraw $ to owner
    """
    assert msg.sender == OWNER_ADDRESS, "Not the contract owner!" 
    send(OWNER_ADDRESS, self.balance)
    for funder:address in self.funders:
        self.funder_to_amount_funded[funder] = 0
    self.funders = []
