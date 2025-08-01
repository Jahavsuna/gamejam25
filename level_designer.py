import json

def get_level_data():
    """
    Guides the user through creating a level and returns the level data in the requested JSON structure.
    """
    try:
        num_segments = int(input("Enter the total number of segments in the level: "))
        if num_segments <= 0:
            print("Invalid input. The number of segments must be positive.")
            return None
    except ValueError:
        print("Invalid input. Please enter a number.")
        return None

    segments = []
    track_outline_list = []

    for i in range(num_segments):
        print(f"\n--- Segment {i + 1} / {num_segments} ---")

        # Print the current track outline
        if track_outline_list:
            print("Track so far: " + "".join(track_outline_list))

        try:
            length = abs(float(input(f"Enter the length of segment {i + 1}: ")))
            dx = float(input(f"Enter the dx for segment {i + 1}: "))
        except ValueError:
            print("Invalid input. Please enter a number.")
            return None

        # Create the segment dictionary
        current_segment = {"length": length, "dx": dx}
        objects_list = []

        # Determine the character for the track outline
        if abs(dx) <= 0.3:
            segment_char = '-'
        elif dx < -0.3:
            segment_char = '/'
        else:
            segment_char = '\\'

        # Initialize feature counters for the current segment
        segment_has_loop = False
        segment_gate_count = 0

        # Add features if the segment's dx is within the specified range
        if abs(dx) <= 0.3:
            print("\nThis segment can have features.")
            while True:
                print("1. Add a Gate")
                print("2. Add a Loopzone")
                print("3. Move on to the next segment")

                choice = input("Enter your choice: ")

                if choice == '1':
                    try:
                        y, x = input("Enter the y,x-coordinates for the Gate: ").split(',')
                        y = float(y.strip())
                        x = float(x.strip())
                        objects_list.append(["Gate", x, y])
                        segment_gate_count += 1
                        print("Gate added.")
                    except ValueError:
                        print("Invalid input. Please enter two numbers separated by a comma (e.g., 100,50).")
                elif choice == '2':
                    try:
                        y = float(input("Enter the y-coordinate for the Loopzone: "))
                        while True:
                            safe_input = input("Enter the 'safe' value (1, 2, or 3) for the Loopzone: ")
                            if safe_input in ["1", "2", "3"]:
                                safe = int(safe_input)
                                break
                            else:
                                print("Invalid input. 'safe' value must be 1, 2, or 3.")

                        while True:
                            target_input = input(f"Enter the 'target' segment index (1 to {i + 1}) for the Loopzone: ")
                            try:
                                target_index = int(target_input)
                                if 1 <= target_index <= i + 1:
                                    # Check if the target segment's dx matches the current segment's dx
                                    if target_index - 1 != len(segments):
                                        target_dx = segments[target_index - 1]['dx']
                                    else:
                                        target_dx = dx
                                    if target_dx == dx:
                                        target = target_index - 1  # Store as 0-indexed
                                        # x is always 0 for Loopzones as requested
                                        objects_list.append(["LoopZone", 0, y, safe, target])
                                        segment_has_loop = True
                                        print("Loopzone added.")
                                        break
                                    else:
                                        print(f"Error: The dx of segment {target_index} ({target_dx}) does not match the current segment's dx ({dx}).")
                                else:
                                    print(f"Invalid input. 'target' must be an index between 1 and {i + 1}.")
                            except ValueError:
                                print("Invalid input. Please enter a number.")

                        # If a valid Loopzone was added, break out of the feature-adding loop
                        if 'target' in locals():
                            break
                    except ValueError:
                        print("Invalid input. Please enter numbers for coordinates and values.")
                elif choice == '3':
                    break
                else:
                    print("Invalid choice. Please choose from the menu.")
        
        # Add the objects list to the segment if it's not empty
        if objects_list:
            current_segment["objects"] = objects_list

        # Add the completed segment to the main list
        segments.append(current_segment)

        # Build the outline string for this segment and add it to the list
        segment_outline = segment_char
        if segment_has_loop:
            segment_outline += 'L'
        if segment_gate_count > 0:
            segment_outline += str(segment_gate_count)

        track_outline_list.append(segment_outline)


    # Final print of the completed track
    print("\n--- Level Generation Complete ---")
    print("Final track outline: " + "".join(track_outline_list))

    return segments

def save_to_json(data, filename="level_design.json"):
    """
    Saves the level data to a JSON file.
    """
    with open(filename, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"\nLevel data saved to {filename}")

if __name__ == "__main__":
    level_data = get_level_data()
    if level_data:
        save_to_json(level_data)
