contract;

use std::{
    auth::msg_sender,
    context::this_balance,
    call_frames::msg_asset_id,
    asset::transfer,
};

abi FuPay {
    #[payable]
    fn transfer(recipient: Identity, amount: u64, asset: Option<AssetId>);
}

impl FuPay for Contract {
    #[payable]
    fn transfer(recipient: Identity, amount: u64, asset: Option<AssetId>) {
        let sender = msg_sender().unwrap();
        let token = asset.unwrap_or(AssetId::default());

        if token == AssetId::default() {
            // For native token, use the amount sent with the transaction
            let native_amount = this_balance(AssetId::default());
            require(native_amount >= amount, "Insufficient native tokens sent");
        }

        transfer(recipient, token, amount);
        
        log(TransferEvent {
            token,
            from: sender,
            to: recipient,
            amount,
        });
    }
}

struct TransferEvent {
    token: AssetId,
    from: Identity,
    to: Identity,
    amount: u64,
}

