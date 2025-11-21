# pragma version 0.4.0
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

minimum_usd: uint256

@deploy
def __init__():
    self.minimum_usd = 5

@internal
@view
def _get_eth_to_usd_rate() -> int256:
    price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
    return staticcall price_feed.latestAnswer()

@external
@payable
def fund():
    """
    Allows users to send $ to this contract.
    Have a minimum $ amount send

    1. How do we send ETH to this contract?
    """
    # wei, ether, gwei
    assert msg.value >= as_wei_value(1, "ether"), "You must spend more ETH!" 
    pass

@external
def withdraw():
    pass
