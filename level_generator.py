import json

def create_segment(segments_so_far):
    """
    Interactively creates a single segment dictionary based on user input.
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

    if input("Do you want to add objects to this segment? (yes/no): ").lower() == 'yes':
        objects = []
        loopzone_y_coords = []
        while True:
            object_type = input("Enter object type ('Gate' or 'LoopZone', or 'done' to finish): ").lower()
            if object_type == 'done':
                break
            elif object_type == 'gate':
                while True:
                    try:
                        x = float(input("Enter Gate x coordinate: "))
                        y = float(input("Enter Gate y coordinate: "))
                        objects.append(["Gate", x, y])
                        break
                    except ValueError:
                        print("Invalid input. Please enter numbers for x and y.")
            elif object_type == 'loopzone':
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
                                if segments_so_far[target_segment]["dx"] != dx:
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
                print("Invalid object type. Please enter 'Gate' or 'LoopZone'.")
        
        # Sort objects by their y-coordinate
        objects.sort(key=lambda item: item[2])
        if objects:
            segment["objects"] = objects

    return segment

def generate_segments():
    """
    Generates a list of segment dictionaries interactively and saves them to a JSON file.
    """
    segments = []
    print("Starting interactive segment generation.")

    while True:
        segments.append(create_segment(segments))
        if input("Add another segment? (yes/no): ").lower() != 'yes':
            break

    # After collecting all segments, validate LoopZone target segments
    for i, segment in enumerate(segments):
        if "objects" in segment:
            for obj in segment["objects"]:
                if obj[0] == "LoopZone":
                    target_segment_index = obj[4]
                    if target_segment_index >= i:
                        print(f"Warning: In segment {i}, LoopZone target segment index {target_segment_index} is not smaller than the current segment index. This may cause issues.")
                    if segments[target_segment_index]["dx"] != segment["dx"]:
                        print(f"Warning: In segment {i}, LoopZone target segment {target_segment_index} has a different dx ({segments[target_segment_index]['dx']}) than the current segment ({segment['dx']}). This may cause issues.")

    filename = input("Enter filename to save (e.g., 'level.json'): ")
    with open(filename, 'w') as f:
        json.dump(segments, f, indent=4)
    print(f"Segments saved to {filename}")

if __name__ == "__main__":
    generate_segments()