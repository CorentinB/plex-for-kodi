from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
PLAYER = ROOT / "lib" / "player.py"


class AudioPlayerContractTests(unittest.TestCase):
    def test_missing_track_comment_is_treated_as_not_ready(self):
        source = PLAYER.read_text()
        start = source.index("    def extractTrackInfo(self):")
        end = source.index("    def setPlayQueue(self, pq):", start)
        extract_track_info = source[start:end]

        self.assertIn("plexID = item.get('comment')", extract_track_info)
        self.assertNotIn("plexID = item['comment']", extract_track_info)


if __name__ == "__main__":
    unittest.main()
