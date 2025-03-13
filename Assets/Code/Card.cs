using UnityEngine;

public class Card : MonoBehaviour
{
    public SpriteRenderer frontRenderer;
    public SpriteRenderer backRenderer;
    public Texture2D cardSheet;

    public int cardWidth = 142;
    public int cardHeight = 190;

    private bool isDragging = false;
    private Vector3 offset;
    private static int sortingOrderCounter = 0; // Keeps track of sorting order

    void Update()
    {
        if (isDragging)
        {
            Vector3 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            transform.position = new Vector3(mousePosition.x + offset.x, mousePosition.y + offset.y, 0);
        }
    }

    void OnMouseDown()
    {
        if (Input.GetMouseButton(0)) // Left Click
        {
            isDragging = true;
            Vector3 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            offset = transform.position - mousePosition;

            BringToFront(); // Make sure the card is on top
        }
    }

    void OnMouseUp()
    {
        isDragging = false;
    }

    public void SetCard(int rank, int suit)
    {
        Rect spriteRect = new Rect(rank * cardWidth, (3 - suit) * cardHeight, cardWidth, cardHeight);
        Sprite cardSprite = Sprite.Create(cardSheet, spriteRect, new Vector2(0.5f, 0.5f));
        frontRenderer.sprite = cardSprite;
    }

    private void BringToFront()
    {
        sortingOrderCounter++;
        frontRenderer.sortingOrder = sortingOrderCounter * 2;
        backRenderer.sortingOrder = (sortingOrderCounter * 2) - 1;
    }
}
