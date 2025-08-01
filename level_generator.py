import json

def create_segment_numeric(segments_so_far):
    """
    Interactively creates a single segment dictionary using only numeric input.
    """
    segment = {}

    while True:
        try:
            length = float(input("Enter segment length (e.g., 300.0): "))
            segment["length"] = length
            break
        except ValueError:
            print("Invalid input. Please enter a number for length.")

    while True:
        try:
            dx = float(input("Enter segment curvature (dx, positive for right, negative for left): "))
            segment["dx"] = dx
            break
        except ValueError:
            print("Invalid input. Please enter a number for dx.")

    # Use numeric choices for "yes/no"
    while True:
        objects = []
        loopzone_y_coords = []
        object_type_map = {"1": "Gate", "2": "LoopZone", "3": "done"}
        
        while True:
            print("\nSelect object type:")
            for key, value in object_type_map.items():
                if value != "done":
                    print(f"  {key}: {value}")
            print(f"  {len(object_type_map)}: Finish adding objects")

            object_choice = input("Enter your choice: ")
            
            if object_choice == '3':
                break
            elif object_choice == '1': # Gate
                while True:
                    try:
                        x = float(input("Enter Gate x coordinate: "))
                        y = float(input("Enter Gate y coordinate: "))
                        objects.append(["Gate", x, y])
                        break
                    except ValueError:
                        print("Invalid input. Please enter numbers for x and y.")
            elif object_choice == '2': # LoopZone
                while True:
                    try:
                        x = float(input("Enter LoopZone x coordinate: "))
                        y = float(input("Enter LoopZone y coordinate: "))

                        # Validate LoopZone proximity
                        is_too_close = False
                        for ly in loopzone_y_coords:
                            if abs(y - ly) < 50:
                                print(f"Error: A LoopZone already exists within 50 units on the y-axis at y={ly}. Please choose a different y coordinate.")
                                is_too_close = True
                                break
                        if is_too_close:
                            continue

                        safe_zone_index = int(input("Enter LoopZone safe zone index (0, 1, or 2): "))
                        
                        while True:
                            try:
                                target_segment = int(input("Enter LoopZone target segment index: "))
                                if target_segment > len(segments_so_far):
                                    print(f"Error: Target segment index {target_segment} is not smaller than the current segment index {len(segments_so_far)}. Please enter a smaller index.")
                                    continue
                                if len(segments_so_far) != 0 and segments_so_far[target_segment]["dx"] != dx:
                                    print(f"Error: Target segment {target_segment} has a different dx ({segments_so_far[target_segment]['dx']}) than the current segment ({dx}). Please choose a target with the same dx.")
                                    continue
                                break
                            except (ValueError, IndexError):
                                print("Invalid input or target segment index. Please enter a valid integer that is smaller than the current segment index.")

                        objects.append(["LoopZone", x, y, safe_zone_index, target_segment])
                        loopzone_y_coords.append(y)
                        break
                    except ValueError:
                        print("Invalid input. Please enter numbers for coordinates and integers for indices.")
            else:
                print("Invalid choice. Please enter 1, 2, or 3.")
        
        # Sort objects by their y-coordinate
        objects.sort(key=lambda item: item[2])
        if objects:
            segment["objects"] = objects

    return segment

def generate_segments_numeric():
    """
    Generates a list of segment dictionaries interactively and saves them to a JSON file.
    All interactions are through numeric input.
    """
    segments = []
    print("Starting interactive segment generation (numeric input only).")

    while True:
        print(f"\n--- Creating Segment {len(segments)} ---")
        segments.append(create_segment_numeric(segments))
        
        while True:
            add_another_choice = input("Add another segment? (1 for Yes, 2 for No): ")
            if add_another_choice == '1':
                break
            elif add_another_choice == '2':
                filename = input("Enter filename to save (e.g., 'level.json'): ")
                with open(filename, 'w') as f:
                    json.dump(segments, f, indent=4)
                print(f"Segments saved to {filename}")
                return
            else:
                print("Invalid choice. Please enter 1 or 2.")

if __name__ == "__main__":
    generate_segments_numeric()

