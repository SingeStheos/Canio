using UnityEngine;

public class CardSpawner : MonoBehaviour
{
    public GameObject cardPrefab;
    public Texture2D cardSheet; // Assign in Inspector, but NOT directly in scene
    public Sprite[] cardBacks;

    void Start()
    {
        // Ensure the spritesheet is not visible in the scene
        if (cardSheet != null)
        {
            GetComponent<SpriteRenderer>().sprite = null;
        }
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(1)) // Right Click
        {
            SpawnCard();
        }
    }

    void SpawnCard()
    {
        GameObject newCard = Instantiate(cardPrefab, Vector3.zero, Quaternion.identity);
        Card cardScript = newCard.GetComponent<Card>();
        cardScript.cardSheet = cardSheet;

        int randomRank = Random.Range(0, 13); // 2 to Ace
        int randomSuit = Random.Range(0, 4); // Hearts to Spades

        cardScript.SetCard(randomRank, randomSuit);
        cardScript.backRenderer.sprite = cardBacks[Random.Range(0, cardBacks.Length)];
    }
}
