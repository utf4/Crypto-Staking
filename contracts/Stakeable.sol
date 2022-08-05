// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


contract Stakeable {
    
    struct stake{
        address user; 
        uint256 amount; 
        uint256 starttime; 
    }
    
    struct stakeholder {
        address staker;
        stake[] total_stakes;
    }
    
    stakeholder [] StakeHolder;
    
    mapping (address => uint256) stakers_index;
    
    event Stake(address staker, uint256 amount, uint256);
    
    uint256 PerHourReward = 100; 
    
    struct UserSummary  {
        address user; 
        uint256 total_staked_amount;
        uint256 total_reward; 
    } 
    
    constructor(){
        
        StakeHolder.push();
    }
    
    function _addstakeholders(address staker_address) internal returns (uint256) {
        
        StakeHolder.push();
        
        uint256 index = StakeHolder.length -1;
        
        stakers_index[staker_address] = index;
        
        
        StakeHolder[index].staker  = staker_address;
        
        return index;
        // return StakeHolder[index].total_stakes.length -1;
        
    }
    
    function _stake(address staker_address, uint256 amount) internal returns (bool) {
        require (amount > 0, "Can not stake 0 ");
        
        uint256 index = stakers_index[staker_address];
        
        if (index == 0){
            index = _addstakeholders(staker_address);
        }
        
        StakeHolder[index].total_stakes.push(stake(staker_address, amount, block.timestamp));
        
        emit Stake (staker_address, amount, block.timestamp);
        return true;
    }
    
    function _withdrawStake(address staker_address,uint256 amount, uint256 stake_index) internal returns (uint256){
         
        uint256 index = stakers_index[staker_address];
        
        stake memory user_stake = StakeHolder[index].total_stakes[stake_index];  
        
        require (user_stake.amount >= amount, "Can not withdraw more than stake");
        
        uint256 reward = _calculateReward (user_stake);
        
        user_stake.amount = user_stake.amount - amount; 
        
        if (user_stake.amount == 0 ){
            delete StakeHolder[index].total_stakes[stake_index];
            
        }
        else{
            StakeHolder[index].total_stakes[stake_index].amount = user_stake.amount; 
            StakeHolder[index].total_stakes[stake_index].starttime = block.timestamp;
        }
        
        return reward;
        
    }
    
    function _calculateReward(stake memory user_stake) view internal returns (uint256){
        
        // index = stakers_index[staker_address];
        
        // stake memory user_stake = StakeHolder[index].total_stakes[index];  
        
        // difference of time 
        
        // for testing purpose only increasing the time to one hour; 
        
        // return (((block.timestamp - user_stake.starttime)/ 1 hours ) *user_stake.amount ) / PerHourReward;  
        
        return ((((block.timestamp + 1 hours )- user_stake.starttime)/ 1 hours ) *user_stake.amount ) / PerHourReward;  
        
    }
    
    function _calculateSummary (address staker_address ) external view returns (UserSummary memory) {
        
        uint256 user_index = stakers_index[staker_address];
        stakeholder memory user_stake_list = StakeHolder[user_index];
        uint256 total_user_stake = user_stake_list.total_stakes.length;
        
        UserSummary memory usersummary;
        usersummary.user = staker_address;
        
        for (uint i =0; i<total_user_stake; i++){
            stake memory user_stake = user_stake_list.total_stakes[i];
            usersummary.total_reward += _calculateReward(user_stake); 
            usersummary.total_staked_amount += user_stake.amount;
        }
        
        return usersummary;
        
    }
    
}