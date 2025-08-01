import json

def create_segment():
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
                        safe_zone_index = int(input("Enter LoopZone safe zone index (0, 1, or 2): "))
                        target_segment = int(input("Enter LoopZone target segment index (must be smaller than current segment): "))
                        objects.append(["LoopZone", x, y, safe_zone_index, target_segment])
                        break
                    except ValueError:
                        print("Invalid input. Please enter numbers for coordinates and integers for indices.")
            else:
                print("Invalid object type. Please enter 'Gate' or 'LoopZone'.")
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
        segments.append(create_segment())
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