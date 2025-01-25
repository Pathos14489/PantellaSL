from src.logging import logging
import src.behaviors.base_behavior as base_behavior

class Behavior(base_behavior.BaseBehavior):
    def __init__(self, manager):
        super().__init__(manager)
        self.keyword = "HaveSex"
        self.description = "If you want to have sex with [player], say '{command}' in your response."
        self.examples = [
            [
                {
                    "role": "user",
                    "name": "Husband",
                    "content":"Wanna have sex?"
                },
                {
                    "role": "assistant",
                    "name": "Wife",
                    "content":"{command} Sure, let's do it."
                },
            ],
            [
                {
                    "role": "user",
                    "name": "Talen-Jei",
                    "content":"Keerava, we should have sex."
                },
                {
                    "role": "assistant",
                    "name": "Keerava",
                    "content":"{command} Of course my husband, let's go to the bedroom."
                },
            ]
        ]
        self.valid_games = ["skyrim","skyrimvr"]
    
    def run(self, speaker_character=None, sentence=None):
        logging.info(f"{speaker_character.name} wants to have sex.")
        self.queue_actor_method(speaker_character,"SexLabHaveSex")