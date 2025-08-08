module MyModule::TipJar {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a tip jar for a specific user
    struct Jar has store, key {
        total_tips: u64, // Total tips received
    }

    /// Function to initialize a tip jar for the signer
    public fun create_jar(user: &signer) {
        let jar = Jar { total_tips: 0 };
        move_to(user, jar);
    }

    /// Function to tip the jar owner
    public fun tip(sender: &signer, jar_owner: address, amount: u64) acquires Jar {
        let jar = borrow_global_mut<Jar>(jar_owner);

        // Transfer coins from sender to jar owner
        let coins = coin::withdraw<AptosCoin>(sender, amount);
        coin::deposit<AptosCoin>(jar_owner, coins);

        // Update total tips
        jar.total_tips = jar.total_tips + amount;
    }
}
