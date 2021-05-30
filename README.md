# NickJohnsonproxycontract

1. Deploy `Example` contract(logic contract). `Example` inherits `Upgradeable` contract to avoid storage collisions.
2. Deploy `Dispatcher` contract(storage contract). Enter `Example` contract address in the constructor.
(Sets `Example` contract functionality in `Dispatcher` address).
3. Tell Remix that the `Example` contract is now running on the `Dispatcher` address. 
When you call a function on the `Example` contract running on the `Dispatcher` address, since the `Dispatcher` contract does not have the functions e.g `setUint` & does not inherit from Example,the `fallback` function is called and it delegateCalls the function to the target address. 
4. When you update the logic smart contract(`Example` contract), you redeploy it and call the `replace` function in the `Dispatcher` to update the new address. 
5. All contracts using the `Dispatcher` need to extend `Upgradeable` to avoid storage collisions.  


