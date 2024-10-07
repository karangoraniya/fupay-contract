

contract;

use std::address::Address;
use std::storage::storage_vec::*;

use std::{
    asset::transfer,
    auth::msg_sender,
    call_frames::msg_asset_id,
    context::msg_amount,
    context::this_balance,
};

abi FuPay {
    #[payable]
    fn transfer(recipient: Address, asset_id: AssetId, amount: u64, reference: u64);
}


impl FuPay for Contract {

    #[payable]
    fn transfer(recipient: Address, asset_id: AssetId, amount: u64, reference: u64) {
        let asset = AssetId::from(asset_id);
        let sender = msg_sender().unwrap();
        

        transfer(Identity::Address(recipient), asset, amount);
        
        log(TransferEvent {
            token: asset,
            from: sender, // Ensure sender is also an Identity
            to: Identity::Address(recipient),
            amount,
            reference,
        });
    }

}

struct TransferEvent {
    token: AssetId,
    from: Identity,
    to: Identity,
    amount: u64,
    reference: u64,
}
