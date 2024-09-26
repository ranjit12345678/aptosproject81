module MyModule::CharityFundraising {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a fundraising campaign.
    struct FundraisingCampaign has store, key {
        total_donations: u64,  // Total donations received
        goal: u64,             // Fundraising goal
    }

    /// Function to create a fundraising campaign with a goal.
    public fun create_campaign(organizer: &signer, goal: u64) {
        let campaign = FundraisingCampaign {
            total_donations: 0,
            goal,
        };
        move_to(organizer, campaign);
    }

    /// Function to donate tokens to the fundraising campaign.
    public fun donate(donor: &signer, organizer_address: address, amount: u64) acquires FundraisingCampaign {
        let campaign = borrow_global_mut<FundraisingCampaign>(organizer_address);

        // Transfer donation from donor to the campaign organizer
        let donation = coin::withdraw<AptosCoin>(donor, amount);
        coin::deposit<AptosCoin>(organizer_address, donation);

        // Update the total donations in the campaign
        campaign.total_donations = campaign.total_donations + amount;
    }
}
