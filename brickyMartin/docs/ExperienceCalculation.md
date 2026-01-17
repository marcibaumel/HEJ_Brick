# Experience Calculation System

## Overview
The experience system in BrickyMartin scales with player progression through levels. As you level up, experience orbs become more valuable and change color to reflect your advancement.

## Experience Points Scaling

### Point Calculation
- **Base Points**: Each experience orb grants 1 base point
- **Level Multiplier**: Points increase by 10% per level
- **Formula**: `scaled_points = base_points × (1.0 + (level - 1) × 0.1)`

### Examples
- Level 1: 1 point per orb
- Level 5: 1.4 points per orb (40% increase)
- Level 10: 1.9 points per orb (90% increase)
- Level 15: 2.4 points per orb (140% increase)

## Level Progression

### Level Up Requirement
- **Experience needed per level**: `level × 10`
- Level 1 → Level 2: 10 experience points
- Level 2 → Level 3: 20 experience points
- Level 5 → Level 6: 50 experience points

## Experience Orb Colors

The color of experience orbs changes based on your current level, providing visual feedback:

| Level Range | Color | Description |
|-------------|-------|-------------|
| 1-4 | Blue | Starting color - foundational progression |
| 5-9 | Purple | Mid-game progression |
| 10-14 | Gold | Advanced progression |
| 15+ | Red | Endgame/mastery level |

### Color Selection
Within each level range, the orb color is **randomly selected** from available colors for that tier, adding visual variety.

## Implementation Details

### Files Modified
- `scripts/game_manager.gd` - Handles `addExp()` function and level scaling
- `scripts/exp.gd` - Manages orb color application and point awards on collection

### Orb Collection
When an experience orb is collected (removed from scene via `_exit_tree()`):
1. Current level is retrieved from GameManager
2. Base points (1) are scaled by level multiplier
3. Scaled points are added to score and experience pool
4. Player levels up if experience pool meets threshold

