import json
import random

def create_random_segment(segments_so_far):
    """
    Creates a single segment dictionary with random values based on specified limits.
    """
    segment = {}

    # Randomly determine if the segment is straight or curved
    is_straight = random.choice([True, False])

    if is_straight:
        segment["dx"] = 0.0
        segment["length"] = random.uniform(100.0, 2000.0)
    else:
        segment["dx"] = random.uniform(-0.5, 0.5)
        # Ensure dx is not 0 for curved segments
        while segment["dx"] == 0:
            segment["dx"] = random.uniform(-0.5, 0.5)
        segment["length"] = random.uniform(100.0, 500.0)

    # Add objects only to straight segments
    if is_straight:
        objects = []
        loopzone_y_coords = []
        gate_y_coords = []
        y_max = segment["length"]

        # Randomly decide how many objects to add
        num_gates = random.randint(0, 5)
        num_loopzones = 1 if random.randint(0, 1) >= 0.5 else 0 # Changed to reduce the probability of LoopZones

        # Add LoopZones first
        loopzone_retries = 0
        MAX_RETRIES = 100
        for _ in range(num_loopzones):
            while True:
                if loopzone_retries >= MAX_RETRIES:
                    print(f"Warning: Could not place loopzone after {MAX_RETRIES} retries. Skipping.")
                    break
                loopzone_y = random.uniform(0, y_max)
                
                # Check for proximity to any existing LoopZones (within 50 units)
                is_too_close_to_loopzone = False
                for ly in loopzone_y_coords:
                    if abs(loopzone_y - ly) < 50:
                        is_too_close_to_loopzone = True
                        break
                
                if not is_too_close_to_loopzone:
                    x = random.uniform(-210, 210) # Set x value for LoopZone between -210 and 210
                    safe_zone_index = random.randint(0, 2)
                    
                    # Find a valid target segment
                    target_segment = len(segments_so_far)
                    if len(segments_so_far) > 0:
                        potential_targets = [i for i, s in enumerate(segments_so_far) if s["dx"] == segment["dx"]]
                        if potential_targets:
                            target_segment = random.choice(potential_targets)
                        
                    objects.append(["LoopZone", x, loopzone_y, safe_zone_index, target_segment])
                    loopzone_y_coords.append(loopzone_y)
                    break
                
                loopzone_retries += 1
        
        # Add Gates
        gate_retries = 0
        for _ in range(num_gates):
            while True:
                if gate_retries >= MAX_RETRIES:
                    print(f"Warning: Could not place gate after {MAX_RETRIES} retries. Skipping.")
                    break
                gate_y = random.uniform(0, y_max)
                
                # Check for the gate density rule (max 3 gates in 150 units)
                gate_y_coords.sort()
                gate_count_in_span = 0
                for y in gate_y_coords:
                    if abs(gate_y - y) <= 150:
                        gate_count_in_span += 1
                
                # Check for proximity to any existing LoopZones
                is_too_close_to_loopzone = False
                for ly in loopzone_y_coords:
                    if abs(gate_y - ly) <= 150:
                        is_too_close_to_loopzone = True
                        break

                if gate_count_in_span < 3 and not is_too_close_to_loopzone:
                    x = random.uniform(-210, 210)
                    objects.append(["Gate", x, gate_y])
                    gate_y_coords.append(gate_y)
                    break
                
                gate_retries += 1

        # Sort objects by their y-coordinate
        objects.sort(key=lambda item: item[2])
        if objects:
            segment["objects"] = objects

    return segment

def generate_random_level(num_segments, filename="random_level.json"):
    """
    Generates a list of random segment dictionaries and saves them to a JSON file.
    """
    segments = []
    total_length = 0
    print(f"Generating a random level with {num_segments} segments...")

    for i in range(num_segments):
        new_segment = create_random_segment(segments)
        segments.append(new_segment)
        total_length += new_segment["length"]
        print(f"Segment {i} created.")

    print(f"\nTotal length of the track is: {total_length}")

    with open(filename, 'w') as f:
        json.dump(segments, f, indent=4)
    print(f"Random level with {len(segments)} segments saved to {filename}")

if __name__ == "__main__":
    num_segments_to_generate = int(input("Enter the number of segments to generate: "))
    generate_random_level(num_segments_to_generate)
